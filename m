Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbZJGXmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbZJGXmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbZJGXmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:42:32 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:38048 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbZJGXmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:42:31 -0400
MIME-Version: 1.0
In-Reply-To: <838c3c32-27d9-4a0a-a197-c7227b911942@VA3EHSMHS014.ehs.local>
References: <1d3f23370910070013u6307bc42hf7ab243b52d007df@mail.gmail.com>
	 <fa686aa40910070634r4a8dcf74qdcbfb3bde3413109@mail.gmail.com>
	 <838c3c32-27d9-4a0a-a197-c7227b911942@VA3EHSMHS014.ehs.local>
Date: Thu, 8 Oct 2009 09:41:55 +1000
Message-ID: <1d3f23370910071641s75b2d217h71a839b1a0b4013c@mail.gmail.com>
Subject: Re: Xilinx SYSACE driver and 8-bit attachment
From: John Williams <john.williams@petalogix.com>
To: John Linn <John.Linn@xilinx.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michal Simek <michal.simek@petalogix.com>,
       David DeBonis <ddeboni@xilinx.com>,
       Stephen Neuendorffer <stephenn@xilinx.com>,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Thu, Oct 8, 2009 at 12:24 AM, John Linn <John.Linn@xilinx.com> wrote:
> I'll look to see if something has changed.  It's not clear to me if it has ever been right.
>
> It look like we normally use 16 bit mode as that's how BSB generates the system by default.

The SP605 reference design uses an 8-bit attachment to the SystemACE -
that's how I found this issue.

John
-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
