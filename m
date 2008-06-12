Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbYFLGGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbYFLGGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYFLGF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:05:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:2963 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYFLGF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:05:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=x+Xm5s6QvrpwVO/g1GonHAg6kUlypBKgIJVPdPV8GGVZfjE8twHxpIZ8ySYrFrOH7t
         i6CIFQqg37qMLM92M9OLyCLWe770s1zwisJP6idYAWBseUTGHEOMFKdLS6IzpfIU/daf
         xc6cc3tLvk1QtJQot8cSuqZfpPIkENNO0okBw=
Message-ID: <c3d0340b0806112305j6e357c39se909fff1dd10c63e@mail.gmail.com>
Date: Wed, 11 Jun 2008 23:05:55 -0700
From: "Shawn Jin" <shawnxjin@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Force a usb drive to be /dev/sda?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is it possible to force a usb drive to be /dev/sda? I put an entire
linux system to a usb drive and want it boot a system with variable
sata disks. However the usb drive is always scanned as a last scsi
drive.

TIA.
-Shawn.
