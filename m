Return-Path: <linux-kernel-owner+w=401wt.eu-S1767755AbXECTYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767755AbXECTYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767756AbXECTYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:24:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:45351 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767755AbXECTYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=o5GkYHg8zPCUZVYAuxOuiDTuG8NCFtFfGEAQx6Bf8NteifM5eWiLLv+fMljIuq5DyKxlbS88exKV98hP1kUPJMxObjn0p8YWeTcbQmYznbddvPc4MtuvN56SsbwtQqeEZafkum3b+gcsM7VSDIHZ08286jN+17tISamHggWxYpA=
Date: Thu, 3 May 2007 23:24:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ben Castricum <mail0704@bencastricum.nl>
Cc: linux-kernel@vger.kernel.org
Subject: kernel BUG at include/net/tcp.h:739 (was Re: kernel panic with 2.6.21-gdc87c398)
Message-ID: <20070503192422.GB5836@martell.zuzino.mipt.ru>
References: <000801c78db5$880fc3c0$0602a8c0@links>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000801c78db5$880fc3c0$0602a8c0@links>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 09:01:56PM +0200, Ben Castricum wrote:
> It crashed again, this time leaving more useable info on screen (see the 
> Crash2.jpg in the same directory).
> 
> >I uploaded all the info into
> >
> >http://www.bencastricum.nl/2.6.21-gdc87c398/

Follow this thread
http://marc.info/?t=117813749500005&r=1&w=2

