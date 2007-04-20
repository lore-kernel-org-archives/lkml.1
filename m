Return-Path: <linux-kernel-owner+w=401wt.eu-S2992797AbXDTNwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992797AbXDTNwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993013AbXDTNwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:52:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:18074 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992797AbXDTNwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:52:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KZJVkEG8CPj1glqydZmh9EprWenn+fiI246WESo0mQjgrib93/r6yADjbesnP3q8YjSIFPDWNtVCiD4fX3iABsvq6/I2GFROwIUwY3h2pI1XzE640bDThvg65MjzYHgyFQuAGDEn+GlpZUgCbRZJqgk/Pj3tfLmwbHBZfDpEMjI=
Subject: Re: [PATCH 01/01] New FBDev driver for Intel Vermilion Range
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Alan Hourihane <alanh@fairlite.demon.co.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1177059856.10128.48.camel@jetpack.demon.co.uk>
References: <1175769886.10382.29.camel@localhost>
	 <1177059856.10128.48.camel@jetpack.demon.co.uk>
Content-Type: text/plain
Date: Fri, 20 Apr 2007 21:51:38 +0800
Message-Id: <1177077098.8463.17.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 10:04 +0100, Alan Hourihane wrote:
> I've updated the Vermilion Range (LE80578) patch against linus' tree.
> 
> Hopefully this rectifies all of the issues noted previously.
> 
> Let me know again if there's more updates needed.
> 
> Thanks to all who responded with the feedback, it was appreciated.
> 

This (at least the framebuffer part) looks good to me (except for the
excessive curly braces, but that can be fixed easily).  Okay if I add a 

Signed-off-by: Alan Hourihane <alanh@fairlite.demon.co.uk>?


Tony


