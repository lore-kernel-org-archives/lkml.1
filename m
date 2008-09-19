Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYISM6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYISM6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 08:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYISM5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 08:57:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbYISM5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 08:57:44 -0400
Message-ID: <48D3A18A.5040003@linux-foundation.org>
Date: Fri, 19 Sep 2008 07:56:42 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org
Subject: Re: [patch 1/4] Make the per cpu reserve configurable
References: <20080918233648.581696416@quilx.com>	 <20080918233701.127757960@quilx.com> <84144f020809190012u1b7dd266q3d2f689b4c2cfdf9@mail.gmail.com>
In-Reply-To: <84144f020809190012u1b7dd266q3d2f689b4c2cfdf9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> 
> Wrong diffstat? There's no ia64 changes in the patch.

Hmmm... I thought quilt would update that...
