Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbXLFQfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbXLFQfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbXLFQfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:35:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44054 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXLFQfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:35:39 -0500
Date: Thu, 6 Dec 2007 17:35:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
Message-ID: <20071206163538.GC20595@one.firstfloor.org>
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206053016.GA1464@cs.unibo.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "This document describes Linux Netlink, which is used in Linux both as
>    an intra-kernel messaging system as well as between kernel and user
>    space."

It can be used between user space daemons as well. In fact it is.
e.g. they often listen to each other's messages.

-Andi

