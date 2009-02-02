Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZBBRPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZBBRPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZBBRPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:15:44 -0500
Received: from bay0-omc2-s22.bay0.hotmail.com ([65.54.246.158]:39240 "EHLO
	bay0-omc2-s22.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbZBBRPo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:15:44 -0500
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Feb 2009 12:15:44 EST
Message-ID: <BAY111-W15F61DA9CA66E14686D5F688C50@phx.gbl>
X-Originating-IP: [128.107.248.220]
From: Krishna Kothapalli <krishna_sunitha@hotmail.com>
To: <kaneshige.kenji@jp.fujitsu.com>, <ebiederm@xmission.com>
CC: <linux-pci@vger.kernel.org>, <jbarnes@virtuousgeek.org>, <achiang@hp.com>,
       <djwong@us.ibm.com>, <xyzzy@speakeasy.org>,
       <linux-kernel@vger.kernel.org>
Subject: RE: Q: state of pci express hotplug
Date: Mon, 2 Feb 2009 12:15:39 -0500
Importance: Normal
In-Reply-To: <4986581F.7060704@jp.fujitsu.com>
References: <m1fxj06js8.fsf@fess.ebiederm.org>
 <4986581F.7060704@jp.fujitsu.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 02 Feb 2009 17:15:40.0118 (UTC) FILETIME=[DF44C760:01C98559]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> I'd like to know details of the bugs. Could you please show the
> details of the bugs?

Not sure if this is a bug or error on my part:

a) Cold plug of the PCI express card looks ok ( the devices show up is the sysfs ). 
b)
However hotplug of the same device does not work (it won't show up in
the sysfs and uevents are not sent to udev ). Same issue when ACPI is removed from the kernel build and
modprobe pciehp pciehp_force=1

Posted some details in (can send in more details if needed) :
http://article.gmane.org/gmane.linux.kernel.pci/2865
http://article.gmane.org/gmane.linux.kernel.pci/2868


_________________________________________________________________
Windows Live™: E-mail. Chat. Share. Get more ways to connect. 
http://windowslive.com/howitworks?ocid=TXT_TAGLM_WL_t2_allup_howitworks_012009