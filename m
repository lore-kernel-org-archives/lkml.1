Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbYGOQk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbYGOQk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYGOQkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:40:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:57144 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbYGOQkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:40:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=asqh3ODcQLkLO1SgLklRgmWYe6Q43goaQHClCH4c8WgIpBPsK7GjYi1dPCZXxWBDHA
         S7LQLFq25dBplayNG5nfTOvJFtLJd8rpJQVZq53EixdMN+19dyQDHZsyoIBMExftVirN
         kY1pnC62TG1Eyuh+O96PZ7V9oL6gQWIpVKh9E=
Message-ID: <86802c440807150940n16a42559n1d9427aabbdb6af1@mail.gmail.com>
Date: Tue, 15 Jul 2008 09:40:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: howarth@bromo.msbb.uc.edu, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 11087] MMCONFIG isn't used under 2.6.26 on second generation MacBook Pro
In-Reply-To: <20080715142229.36C1F108048@picon.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-11087-5966@http.bugzilla.kernel.org/>
	 <20080715142229.36C1F108048@picon.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 7:22 AM,  <bugme-daemon@bugzilla.kernel.org> wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11087
>
>
>
>
>
> ------- Comment #4 from howarth@bromo.msbb.uc.edu  2008-07-15 07:22 -------
> Is this possibly due to the fact that I have 3 GB of ram installed? Is there
> any kernel options that would fake out the kernel to believe the machine has
> less than 3 GB (to avoid having to physically remove the ram)?
>
let check how 2.6.25.10 do at first...

YH
