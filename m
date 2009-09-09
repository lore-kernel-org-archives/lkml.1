Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZIIP2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZIIP2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZIIP2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:28:52 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48703 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbZIIP2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:28:52 -0400
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0909081511590.26432@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com>
	 <1251129384.22398.7166.camel@nimitz>
	 <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
	 <1251150156.22398.8289.camel@nimitz>
	 <alpine.DEB.2.00.0908241540480.12448@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0909081511590.26432@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 08:28:49 -0700
Message-Id: <1252510129.14385.37045.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 15:26 -0700, David Rientjes wrote:
> I'm struggling to find other examples.  Dave, do you know of any 
> subsystems in the kernel that can readily be converted to using flex 
> array?

I don't know of any offhand.  Someone mentioned oprofile buffers at some
point, but I looked through it and it didn't pop out at me.

-- Dave

