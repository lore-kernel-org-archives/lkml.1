Return-Path: <linux-kernel-owner+w=401wt.eu-S1757666AbXFVO0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbXFVO0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbXFVO0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:26:48 -0400
Received: from ns2.suse.de ([195.135.220.15]:45373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbXFVO0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:26:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] doc/oops-tracing: add Code: decode info
Date: Fri, 22 Jun 2007 16:26:39 +0200
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
In-Reply-To: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706221626.39969.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007 07:51:08 Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add info that the Code: bytes line contains <xy> or (wxyz) in some
> architecture oops reports and what that means.
> 
> Add URL for a script by Andi Kleen that reads the Code: line from an Oops
> report file and generates assembly code from the hex bytes.
> (This script does not handle Code: lines that contain <xy> or (wxyz)
> markings.)

Should probably fix that and put it into scripts/ then

-Andi
