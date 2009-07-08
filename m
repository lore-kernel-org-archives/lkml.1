Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbZGHGvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbZGHGvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758989AbZGHGvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:51:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:60878 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZGHGvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MpcF4V1Dal/KQTHwWHcfWQcSAZCQpcSQvfpviOR8ivOruvBP0VZOreHJKMlma4ByQf
         5kXVp4lo7RZpEPCLjewbjpJAkFK7CLbtNxbQmyUsw1VcZ6ozaFZKFSC/WSazvDVvRyxD
         cDMiMwHJ513U+wJPV2fLmLXtGJTx5ga3VaPfE=
Date: Tue, 7 Jul 2009 23:51:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jim Persson <jim-linux@nurd.se>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Daniel Ritz <daniel.ritz@gmx.ch>
Subject: Re: [PATCH] usbtouchscreen: support for JASTEC/DigiTech DTR-02U
	USB touch controllers
Message-ID: <20090708065116.GC3309@dtor-d630.eng.vmware.com>
References: <20090705131306.GC23869@nurd.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705131306.GC23869@nurd.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 03:13:06PM +0200, Jim Persson wrote:
> add support for the JASTEC/DigiTech DTR-02U USB touch screen
> controllers. 
> 
> Signed-off-by: Jim Persson <jim-linux@nurd.se>

Applied, thank you Jim.

-- 
Dmitry
