Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbXCJPzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbXCJPzT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 10:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933472AbXCJPzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 10:55:19 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:14358 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767851AbXCJPzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 10:55:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=e5uTybMnMJXyemqrqH/F9oMcTP51pMKN5+5m+KZMquJ0Wc29R4oes0o3JQFGbet/iWmaj2EpVh/fjPj4VjnYavR9DGWIP+xcEP2nX4XYdK2xfGhuJN7gZ2xbNFTLPNwIPFasm4TOXkj1l7POj3THeWzAj6vcCapNMhwxEoKUzEY=
Message-ID: <48f7fe350703100755i75d2a56al981da1fbda645ddc@mail.gmail.com>
Date: Sat, 10 Mar 2007 10:55:16 -0500
From: "Ryan Hope" <rmh3093@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: pciehp: Cannot get control of hotplug hardware
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ever since I started playing with suspend I started turning on PCI Hot
Plug support.... since then I have been seeing messages like whats
below from dmesg.... I'm not exactly sure how this actually impacts me
if it does at all. I just thought it didn't look exactly right so I
wanted to inquire about it. Does anyone know what is going on here?

-Ryan

pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
decode_hpp: Could not get hotplug parameters. Use defaults
pciehp: HPC vendor_id 8086 device_id 27d0 ss_vid 0 ss_did 0
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
pciehp: Cannot get control of hotplug hardware for pci 0000:00:1c.0
pciehp: HPC vendor_id 8086 device_id 27d2 ss_vid 0 ss_did 0
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
pciehp: Cannot get control of hotplug hardware for pci 0000:00:1c.1
pciehp: HPC vendor_id 8086 device_id 27d4 ss_vid 0 ss_did 0
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
pciehp: Cannot get control of hotplug hardware for pci 0000:00:1c.2
pciehp: HPC vendor_id 8086 device_id 27d6 ss_vid 0 ss_did 0
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
pciehp: Cannot get control of hotplug hardware for pci 0000:00:1c.3
pciehp: HPC vendor_id 8086 device_id 27e0 ss_vid 0 ss_did 0
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
pciehp: Cannot get control of hotplug hardware for pci 0000:00:1c.4
pciehp: HPC vendor_id 8086 device_id 27e2 ss_vid 0 ss_did 0
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
pciehp: Cannot get control of hotplug hardware for pci 0000:00:1c.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
