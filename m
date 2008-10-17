Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYJQNL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYJQNL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYJQNLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:11:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789AbYJQNLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:11:18 -0400
Message-ID: <48F88EC2.3090601@linux-foundation.org>
Date: Fri, 17 Oct 2008 08:10:26 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nathalie Furmento <nathalie.furmento@labri.fr>
Subject: Re: [RESEND][PATCH] mm: rework do_pages_move() to work on page_sized
 chunks
References: <48F3AD47.1050301@inria.fr> <48F3AE1D.3060208@inria.fr> <48F79B42.3070106@linux-foundation.org> <48F87885.5000606@inria.fr>
In-Reply-To: <48F87885.5000606@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Christoph Lameter <cl@linux-foundation.org>

