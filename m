Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYASM1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYASM1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 07:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYASM1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 07:27:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:25060 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYASM1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 07:27:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=vC1Y0wICWnU2AEBp+oNmN6KhO3LCzPiStkgVUhl/gi82rbIOX613w0QJVG9+hymTMIldxi78nz7lkskmO+WZQ7ZuKuExjKfoYPh1Of+aHaboyDcRJfynyz7c0iDPmxAbqQrdRZ4eTe2JEnVu+aHWoVIabAdiYoRorl0ot4tnRFE=
Message-ID: <46f38fe70801190427p7d50beaeo67571b935a896283@mail.gmail.com>
Date: Sat, 19 Jan 2008 20:27:30 +0800
From: "goodmen zy" <goodmenkernel@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: About the saa7146 driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have a PCI video capture card, and the command `lspci` tell me the
following info:

     00:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)

In the kernel source, I compiled the module saa7146.ko and saa7146_vv.ko.
Those modules were inserted into kernel successfully.
But I can't find any new device file in /dev.

Can you tell me the reason?

Does the saa1746 module plays as a common driver for all the device
with that chip?

Thanks!
