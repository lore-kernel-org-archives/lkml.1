Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbXLFQfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbXLFQfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXLFQez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:34:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44049 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbXLFQey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:34:54 -0500
Date: Thu, 6 Dec 2007 17:34:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Newall <david@davidnewall.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Renzo Davoli <renzo@cs.unibo.it>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
Message-ID: <20071206163451.GB20595@one.firstfloor.org>
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <2BD0AF2A-959D-4744-9D2A-3AE84CF96CBB@mac.com> <47579DEB.9020102@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47579DEB.9020102@davidnewall.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Renzo also described something new (in the socket() arena): the 
> multi-reader, multi-writer is just not available in IP.

How is that different from a multicast group?

-Andi
