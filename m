Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZG1O6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZG1O6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZG1O6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:58:39 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:38920 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZG1O6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=vMDWL0VtOfN49hOBzpDiPeKNVVJLichoCbXKA9PwXSLWnzCxfzcsCxjFyzzPCDZmmw
         1T6ehntyWvq3nGZOP4hXg9KuS92unRbPgzBv43uK55o1JWSEFQHTTCY3ozn1aKjsCPlM
         VXHf0/9oUIm957s9+/8NCz/Fv46Iw8XllxkFQ=
MIME-Version: 1.0
Date: Tue, 28 Jul 2009 07:58:39 -0700
Message-ID: <110c8b2e0907280758n5854e745k70ef750d6f4385a1@mail.gmail.com>
Subject: initramfs linked into kernel & GPL issue
From: Subodh Nijsure <nijsure.subodh@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  Not exactly technical kernel issue. I have done google search for
initramfs+GPL and didn't come across discussion on mailing list hence
the question. ]

We are currently wondering what issues there might be if one were to
link the initramfs into the kernel.

This initramfs will have some proprietary modules, does this mean one
has to release source code for the modules included in such a
initramfs?


/Subodh Nijsure
