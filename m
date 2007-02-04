Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbXBDQBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbXBDQBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 11:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXBDQBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 11:01:41 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:52576 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbXBDQBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 11:01:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Thmrv2G2q4quBwOZhHs8RRU0I1/viTnlKxlpsJR4WGMZq1D1CawF5IN+hN/SoHKehZJao1Erf6zCve2qexv7iCp97ld62g//56U7J4vZ6MtHuGoNJWr93gCPFxGSlTPbRjXkIGOt4Su9Qif6g+LtmXDBxMmzyX7H/ct+BX3S/Mg=
Message-ID: <8d158e1f0702040801g47e6f4f3mfd37da6aa13d9e0e@mail.gmail.com>
Date: Sun, 4 Feb 2007 17:01:39 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: More pata_ stuff
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to use the new pata drivers on a Dual PII-400Mhz with the
Intel PIIX controller.

Unfortunately the controller doesn't get detected on boot time, the
old IDE drivers do work and see the controller as a PIIX4 chipset,
which is correct.

The mainboard is a Asus P2B with integrated Adaptec SCSI host and the
PIIX controller.


Patrick
