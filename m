Return-Path: <linux-kernel-owner+w=401wt.eu-S934345AbYBUVUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345AbYBUVUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYBUVTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:19:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38514 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYBUVTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:19:34 -0500
Date: Thu, 21 Feb 2008 21:19:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] saa7146: fix sparse warnings
Message-ID: <20080221211927.GB27894@ZenIV.linux.org.uk>
References: <1203616356.20345.45.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203616356.20345.45.camel@brick>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 09:52:36AM -0800, Harvey Harrison wrote:

Could you please use more descriptive names?  NULL noise removal
is not the same as shadowing or endianness annotations or endianness
fixes or __user/__iomem annotations/fixes, etc.
