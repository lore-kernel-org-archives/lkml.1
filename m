Return-Path: <linux-kernel-owner+w=401wt.eu-S1752258AbZL2QG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbZL2QG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 11:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZL2QGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 11:06:24 -0500
Received: from smtp.seznam.cz ([77.75.76.43]:43186 "EHLO smtp.seznam.cz"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752560AbZL2QGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 11:06:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=aiUc4oojkIB4UhtFdtwCOBeFm6tQtqiQDxbmk6OVTeARRDFy6eX6M/CnmCmZxsKdk
	od4pfU0oqG7vol8o2WCaUctPxeCG1GwgDqYPo2h985cG6V2Gaqwvi4drUyrsLP2MyXd
	tyKxbD4VfyEh0KpnoEphZUZcrX1brqIj/P5MaTI=
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #14846] acer-wmi kernel OOPS, cannot create duplicit sysfs name
Date: Tue, 29 Dec 2009 16:37:28 +0100
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.ck.mnhOLB@chimera>
In-Reply-To: <NJVdobuNFNK.A.ck.mnhOLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912291637.29088.oldium.pro@seznam.cz>
X-Smtpd: 1.1.7@13984
X-Seznam-User: oldium.pro@seznam.cz
X-QM-Mark: email-qm3<397177928>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 29 of December 2009 at 16:09:57, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).

When the patch is applied to 2.6.33-rc2, the regression goes away. The patch 
fixes the problem.

Cheers,
Oldrich.

>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14846
> Subject		: acer-wmi kernel OOPS, cannot create duplicit sysfs name
> Submitter	: Oldřich Jedlička <oldium.pro@seznam.cz>
> Date		: 2009-12-19 23:44 (11 days old)
> Handled-By	: Carlos Corbacho <carlos@strangeworlds.co.uk>
> Patch		: http://patchwork.kernel.org/patch/69795/


