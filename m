Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbYI3Tds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbYI3Tds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYI3Tdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:33:40 -0400
Received: from lazybastard.de ([212.112.238.170]:38345 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYI3Tdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:33:39 -0400
Date: Tue, 30 Sep 2008 21:33:19 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       penberg <penberg@cs.helsinki.fi>, mpm <mpm@selenic.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: reduce total stack usage of slab_err & object_err
Message-ID: <20080930193318.GA31146@logfs.org>
References: <1222787736.2995.24.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1222787736.2995.24.camel@castor.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 September 2008 16:15:36 +0100, Richard Kennedy wrote:
> 
> I've been trying to build a tool to estimate the maximum stack usage in
> the kernel, & noticed that most of the biggest stack users are the error
> handling routines.

Cool!  I once did the same, although the code has severely bitrotted by
now.  Is the code available somewhere?

Jörn

-- 
"Error protection by error detection and correction."
-- from a university class
