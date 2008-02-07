Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbYBGMKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbYBGMKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbYBGMJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:09:53 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:52514 "EHLO
	outbound6-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754371AbYBGMJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:09:51 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Thu, 7 Feb 2008 13:09:09 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH][RFC] SVM: Add Support for Nested Paging
 in AMD Fam16 CPUs
Message-ID: <20080207120909.GE6960@amd.com>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
 <479C4763.1080104@qumranet.com>
MIME-Version: 1.0
In-Reply-To: <479C4763.1080104@qumranet.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 07 Feb 2008 12:09:09.0659 (UTC)
 FILETIME=[3E93AEB0:01C86982]
X-WSS-ID: 6BB42A880QK10778722-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 10:57:07AM +0200, Avi Kivity wrote:
> Very nice patchset; small, simple, and clean.  Apart from the comments
> I already posted, I'd like to avoid the term 'hap': I find it
> non-descriptive, and it reminds me of another hypervisor.  I suggest
> 'tlp' for two-level paging.

I renamed HAP to TDP. This stands for Two-Dimensional Paging and is the
term which descibes best what happens in my opinion.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


