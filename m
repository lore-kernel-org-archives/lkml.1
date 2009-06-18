Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbZFRNwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbZFRNwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 09:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbZFRNwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 09:52:17 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:37882 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755551AbZFRNwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 09:52:16 -0400
Date: Thu, 18 Jun 2009 09:51:46 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <srostedt@redhat.com>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, kyle@mcmartin.ca,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, David Howells <dhowells@redhat.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, arm@redhat.com
Subject: Re: [PATCH 6/9 UPDATED] percpu: enforce global definition
In-Reply-To: <1245331597.5195.8.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0906180951270.15556@gentwo.org>
References: <1245210060-24344-1-git-send-email-tj@kernel.org>  <1245210060-24344-7-git-send-email-tj@kernel.org>  <4A39EF13.7010309@kernel.org> <1245331597.5195.8.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Steven Rostedt wrote:

> Uh, wont this cause name space collisions?

There was an earlier cleanup patch that deal with potential collisions.

