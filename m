Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYCLEwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYCLEwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 00:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYCLEwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 00:52:06 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:58196 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbYCLEwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 00:52:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QXSBHe8z3a76tEHVW7t+xBACYGr0DN1PZnERbGFYv+s02DLcABrZpOZrsanNf+fkm7UYyIkfpe43CwzVKI15KtfCRfZ8q+ehwn4G1sMJGd32tWwtYJcc2SVOwGrh1jk42FXISVyKyb1Pcby+wTT1voyfM2g39EhQscezrJrd0xk=
Message-ID: <4f2ee0160803112152y21bb99a7t331fc9eff214e756@mail.gmail.com>
Date: Tue, 11 Mar 2008 23:52:00 -0500
From: "Prakhar Krishna" <prakhar2@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: How to compile kernel so it automatically reboots upon a crash instead of generating stack trace and then hang.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I did search the mailing lists archives and the Web but did not find an answer,
 apololgies if this is duplicate question]

i need my linux box to automatically reboot if it ever runs into a
kernel panic/crash etc.
For my production evvironment, it is not desired that kernel generate the stack
trace and then wait there. We want it to reboot and comeback up again.

if this has already been answered (i seriously think it should have
been), please
direct me to the answer else any details would be helpful.

I am not subscribed so please CC me on the reply.

thanks
PK
