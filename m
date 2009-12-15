Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbZLORwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbZLORwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759908AbZLORwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:52:13 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:63995 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759988AbZLORwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:52:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RZEAC8hoThs3kNT6g30HEnpc3B5GTjEjn7mC/r66WMui+lOmNBjmEVe0OaxTHbLKtb
         MqYvDqzIFlh4BAefWUJytViFeRT50nszF8WmUHJdUqtmFfMPQq2Vj22yP/eu1h0cFucY
         FkKB2s00U4sENXOwsg/xqCvrUdhQ5m4u1pqvo=
Date: Tue, 15 Dec 2009 09:52:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: Fix test of unsigned in altera_ps2_probe()
Message-ID: <20091215175200.GB21995@core.coreip.homeip.net>
References: <4B27C140.6000105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27C140.6000105@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 06:02:56PM +0100, Roel Kluin wrote:
> ps2if->irq is unsigned so the test does not work.
> 

Applied, tahnk you.

-- 
Dmitry
