Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYCHHbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYCHHbx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 02:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYCHHbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 02:31:45 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44887 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750823AbYCHHbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 02:31:44 -0500
Date: Fri, 7 Mar 2008 23:31:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [8/13] Enable the mask allocator for x86
In-Reply-To: <86802c440803072235r3ca6013cufae3ed62cd67e60f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803072330001.12987@schroedinger.engr.sgi.com>
References: <200803071007.493903088@firstfloor.org> 
 <20080307090718.A609E1B419C@basil.firstfloor.org> 
 <Pine.LNX.4.64.0803071832500.12220@schroedinger.engr.sgi.com>
 <86802c440803072235r3ca6013cufae3ed62cd67e60f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Yinghai Lu wrote:

> How about system with only 4G or less?

Then it does not matter unless the devices can only access 1G or 2G.

