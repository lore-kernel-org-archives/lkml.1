Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbXFIUOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbXFIUOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759044AbXFIUO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:14:26 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:59427 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759006AbXFIUO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:14:26 -0400
Date: Sat, 9 Jun 2007 22:14:20 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: dummy@foobar-g4
To: Willy Tarreau <w@1wt.eu>
cc: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove bashisms from scripts/extract-ikconfig
In-Reply-To: <20070609195333.GR943@1wt.eu>
Message-ID: <alpine.DEB.0.99.0706092211210.8312@foobar-g4>
References: <alpine.DEB.0.99.0706092117580.8312@foobar-g4>
 <2F6FAF9E-8997-4FC1-8310-4A7D17C659E4@ac.upc.edu> <alpine.DEB.0.99.0706092132200.8312@foobar-g4>
 <20070609195333.GR943@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Willy Tarreau wrote:
> That's wrong. It will now require "expr" to be present and working on
> the machine, eventhough it's certainly needed for other parts of the

Oh, I was under the strange assumption that "expr" was a shell-builtin. 
Well, it's not so I guess I'll just live with the bashism or try to 
implement your proposals.

Thank you both for your comments,
Christian.
-- 
make bzImage, not war
