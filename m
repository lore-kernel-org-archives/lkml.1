Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbYF3X4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbYF3X4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 19:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYF3X4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 19:56:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:44983 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbYF3X4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 19:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=fCWmoNxlvCNuiYHXTw+TcVigG27/NwbsuXDYv+uEo8/Nva7lsK9C+g76rrzyBvFo6a
         G5GuAy+l0FxYhItPuSGoUG8nuzlyTalhuDDT6Jpnztqltba6AhEkOenzuzSJWDs215Eq
         wc3hCKzX1cPFaDke+2DCWdMTsRPk1oC+a+fA8=
Message-ID: <396556a20806301656ydc44e3ey6deb229ab69904@mail.gmail.com>
Date: Mon, 30 Jun 2008 16:56:13 -0700
From: "Adam Langley" <agl@imperialviolet.org>
To: "Peter Palfrader" <peter@palfrader.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.25.6: warn_on_slowpath in tcp_input.c
In-Reply-To: <20080630230954.GS16698@anguilla.noreply.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080630230954.GS16698@anguilla.noreply.org>
X-Google-Sender-Auth: 91c7bc849b588b60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 4:09 PM, Peter Palfrader <peter@palfrader.org> wrote:
> I've had 13 or so of them since upgrading the machine to a 2.6.25 kernel
> 20 days ago.

Which kernel was it running before?

AGL

-- 
Adam Langley agl@imperialviolet.org http://www.imperialviolet.org
