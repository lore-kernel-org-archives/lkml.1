Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZCJRmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZCJRmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbZCJRmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:42:06 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:32925 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755012AbZCJRmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:42:05 -0400
Date: Tue, 10 Mar 2009 13:40:02 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com,
       linux-mm@kvack.org, npiggin@suse.de
Subject: Re: PROBLEM: kernel BUG at mm/slab.c:3002!
In-Reply-To: <49B68450.9000505@hp.com>
Message-ID: <alpine.DEB.1.10.0903101339210.9350@qirst.com>
References: <49B68450.9000505@hp.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh nice memory corruption. May have something to do with the vmap work by
Nick.
