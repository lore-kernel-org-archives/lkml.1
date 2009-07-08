Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbZGHG6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbZGHG6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759450AbZGHG5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:57:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:2012 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759222AbZGHG5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VPKKz3/av7I82MuE40IoN2uaDMpi2T2gmGz5aWAhoc7X6ID4jcKK3KL9JUY4mjwLPl
         GD+HLrCHbKTx2Ig6FeomRF+iC7W6AtAc9+XNFgD5hK0kqKy/fOA4HIBRjX0g27mMS6tL
         YalNgRy3R/hdRQd4K3WewbxVRJJaeHxXFXtGk=
Date: Tue, 7 Jul 2009 23:51:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/input: Use resource_size
Message-ID: <20090708065105.GB3309@dtor-d630.eng.vmware.com>
References: <Pine.LNX.4.64.0907050835530.27464@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907050835530.27464@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 08:36:22AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use the function resource_size, which reduces the chance of introducing
> off-by-one errors in calculating the resource size.
> 

Applied, thank you Julia.

-- 
Dmitry
