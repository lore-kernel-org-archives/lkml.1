Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbXJAUE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbXJAUE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXJAUEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:04:48 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33924 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXJAUEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:04:48 -0400
Date: Mon, 1 Oct 2007 15:04:32 -0500
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pcmcia@lists.infradead.org, Dominik Brodowski <linux@brodo.de>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplify yenta code
Message-ID: <20071001200432.GE4338@austin.ibm.com>
References: <20071001184115.GB4338@austin.ibm.com> <20071001185655.GM12049@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001185655.GM12049@parisc-linux.org>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 12:56:55PM -0600, Matthew Wilcox wrote:
> 
> Are BRIDGE_IO_MAX and BRIDGE_MEM_MAX guaranteed to be the same?

@#$%^&*. Red-faced, I withdraw the patch. Must be cross-eyed on
a Monday morning. Sorry.

--linas
