Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbZFBEzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbZFBEzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZFBEzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:55:11 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:44197 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZFBEzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:55:10 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2009 00:55:09 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=X+egG+Opcmg6usN+ywV4jdZDU4YBBuJBeaT3NG1C1b8EwXU7mA9HfaDT+ByVD0p04P
         3Knw18rW2Wg3AWhOBkhDl9rCRpOPI0U/qwB48RyQVKBaD8nv46fN8vxwt0qrbzezRtro
         nOFt3djMIiOd3NhdgJtAg3S0Nwf37JB/KbOOo=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <cfd18e0f0906012145h28827eccu1d9fa2aed2e7355@mail.gmail.com>
References: <20090526175622.687B.A69D9226@jp.fujitsu.com>
	 <cfd18e0f0906012145h28827eccu1d9fa2aed2e7355@mail.gmail.com>
Date: Tue, 2 Jun 2009 06:49:55 +0200
Message-ID: <cfd18e0f0906012149l1f567acdxdde9c65f9408b368@mail.gmail.com>
Subject: Re: poll never return EBADF?
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Why don't we remove EBADF description?
>
> Yes, that seems corrrrect for me. I've removed it for the next release (3.22).

And I forgot to say: thanks for the very detailed bug report!

Cheers,

Michael
-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
