Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZD1LcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZD1LcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZD1LcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:32:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47486 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbZD1LcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:32:08 -0400
Subject: Re: [patch] slub: add Documentation/ABI/testing/sysfs-kernel-slab
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0904241625460.10046@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904231136390.20852@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0904231137440.20852@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0904231436410.7406@qirst.com>
	 <alpine.DEB.2.00.0904241625460.10046@chino.kir.corp.google.com>
Date: Tue, 28 Apr 2009 14:32:06 +0300
Message-Id: <1240918326.1982.18.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-24 at 16:26 -0700, David Rientjes wrote:
> Adds documentation for the slub ABI.
> 
> This is placed in the `testing' directory since the meanings of these
> files are still subject to change as slub is developed.
> 
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Applied, thanks!

