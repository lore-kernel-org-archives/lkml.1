Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbZBDTPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbZBDTPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZBDTPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:15:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:44447 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZBDTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:15:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sql9AGFKSdmZ5BX760O6tNluuYeaZqmEn8PR+bTyO7sxCkg2RF2ze0QThBprXrIYpt
         +wtLVF7yveclpvreesabzBDVZ7xNWcfgLvzFYtBEAHOwB38ywmVsko9lYJ3NjAqOPoBY
         /Dyzag9p5IDUMQ0YTHukpiw7sjvAZe67f9g60=
MIME-Version: 1.0
In-Reply-To: <pWZw1SZjMCH.A.zq.WwYiJB@chimera>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <pWZw1SZjMCH.A.zq.WwYiJB@chimera>
Date: Thu, 5 Feb 2009 03:15:29 +0800
Message-ID: <b6a2187b0902041115u130fcfe7ha1612e2e2fa1ec36@mail.gmail.com>
Subject: Re: [Bug #12414] iwl4965 cannot use "ap auto" on latest 2.6.28/29?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 6:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12414
> Subject         : iwl4965 cannot use "ap auto" on latest 2.6.28/29?
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2009-01-05 4:13 (31 days old)
> References      : http://marc.info/?l=linux-kernel&m=123112882127823&w=4

Latest linux git pull seems to behave slightly better. Restarting the
interface a few times fixes the problem 70% of the time. The rest of
the time, it can't associate with the AP.

Jeff.
