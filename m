Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbZKOSAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbZKOSAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 13:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZKOSAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 13:00:42 -0500
Received: from fifo99.com ([67.223.236.141]:36465 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbZKOSAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 13:00:41 -0500
Subject: Re: [PATCH 4/5] acpi: fix trivial warning
From: Daniel Walker <dwalker@fifo99.com>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <4B00403E.3090907@gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-5-git-send-email-felipe.contreras@gmail.com>
	 <1252936556.28368.215.camel@desktop>
	 <94a0d4530909140734q51779b76g2ddc7211ece87171@mail.gmail.com>
	 <1252940549.28368.255.camel@desktop>
	 <94a0d4530911111623h1ae3463dte8a3f83ec0ad1f75@mail.gmail.com>
	 <1258134207.6411.0.camel@c-dwalke-linux.qualcomm.com>
	 <94a0d4530911131228s6b6b6221o7b24002ca03373e5@mail.gmail.com>
	 <1258305351.6428.8.camel@desktop>
	 <94a0d4530911150927l3224e815ha6ff17aab6f19251@mail.gmail.com>
	 <1258306352.6428.10.camel@desktop>  <4B00403E.3090907@gmail.com>
Content-Type: text/plain
Date: Sun, 15 Nov 2009 09:58:35 -0800
Message-Id: <1258307915.6428.14.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-15 at 20:54 +0300, Alexey Starikovskiy wrote:
> You've made changes to automatically generated files, so all the style 
> changes
> would be overwritten when next time these files are generated -- all the 
> files go through
> Lindent, and almost all your changes were introduced by it. If you 
> really want to make
> style changes to ACPICA files, try to play with Lindent, so it produce 
> what you want.
> If you have anything beside style patches, please submit them separately
> 

AFAIK, Lindent can't produce checkpatch clean output. It has to do with
various short comings in indent. You really need a human to check up on
it.

Daniel

