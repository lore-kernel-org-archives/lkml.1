Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbZFQRA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbZFQRA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbZFQRAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:00:48 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:35742 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751979AbZFQRAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:00:48 -0400
Date: Wed, 17 Jun 2009 13:00:44 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, Jesper.Nilsson@axis.com,
       benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Jones <davej@redhat.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       linux-mm <linux-mm@kvack.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5/9] percpu: clean up percpu variable definitions
In-Reply-To: <1245210060-24344-6-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.1.10.0906171300190.1695@gentwo.org>
References: <1245210060-24344-1-git-send-email-tj@kernel.org> <1245210060-24344-6-git-send-email-tj@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The wrapping fixes could have been put in the earlier patch.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>


