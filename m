Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZL2QSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZL2QSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 11:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZL2QSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 11:18:14 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48824 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbZL2QSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 11:18:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oY+FvE5BlryVK1fvLoAsXwN1UrPzN0/5xBx9ILZTu6cVbzi8Uenaeuh5qu/FhikkXg
         HVFU2Ajv5u0Nxqc9Yi2oB9yQZbFtdCmHmaZyhW/aaq0CiviGvxP3a2endZqjGsbUFcor
         1q5tOMczT5BoK4NwPLzioJqvWLIKblFz+fOjQ=
MIME-Version: 1.0
In-Reply-To: <srmJ8vMxKPH.A.L5E.RyhOLB@chimera>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
	 <srmJ8vMxKPH.A.L5E.RyhOLB@chimera>
Date: Tue, 29 Dec 2009 16:18:11 +0000
Message-ID: <99598f620912290818s29ece3d2uf36bc9125b46ea48@mail.gmail.com>
Subject: Re: [Bug #14436] Computer becomes unusable without any apparent 
	reason
From: =?ISO-8859-1?Q?Lu=EDs_Picciochi_Oliveira?= <pitxyoki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The bug is present on 2.6.32 and subsequent versions (2.6.32.1, 2.6.32.2).
It has been resolved as of 2.6.33-rc1.

Regards,
Luís Picciochi

On Tue, Dec 29, 2009 at 3:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14436
> Subject         : Computer becomes unusable without any apparent reason
> Submitter       : Pitxyoki <Pitxyoki@gmail.com>
> Date            : 2009-10-18 18:32 (73 days old)
>
>
