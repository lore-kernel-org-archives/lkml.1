Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbZHZUkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbZHZUkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZHZUku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:40:50 -0400
Received: from smtp4.ultrahosting.com ([74.213.175.253]:34540 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751074AbZHZUku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:40:50 -0400
Date: Wed, 26 Aug 2009 16:40:09 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, raz ben yehuda <raziebe@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, andrew motron <akpm@linux-foundation.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <20090826193252.GA14721@elte.hu>
Message-ID: <alpine.DEB.1.10.0908261627110.5554@gentwo.org>
References: <1251282598.3514.20.camel@raz> <alpine.DEB.1.10.0908260943090.9924@gentwo.org> <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz> <1251300625.18584.18.camel@twins> <alpine.DEB.1.10.0908261136590.9933@gentwo.org>
 <1251302598.18584.31.camel@twins> <alpine.DEB.1.10.0908261211340.9933@gentwo.org> <20090826180407.GA13632@elte.hu> <alpine.DEB.1.10.0908261509580.9933@gentwo.org> <20090826193252.GA14721@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Ingo Molnar wrote:

> ( If you on the other hand were approaching this issue with
>   pragmatism and with intellectual honesty, if you were at the end
>   of a string of patches that gradually improved latencies but
>   couldnt get them below a certain threshold, and if scheduler
>   developers couldnt give you any ideas what else to improve, and
>   _then_ suggested some other solution, you might have a point.
>   You are far away from being able to claim that. )

Intellectual honesty? Wish I would be seeing it. So far there is not even
the uptake required on your side to discuss the problem.

There is no threshold. HPC and other industries want processors as
a whole with all their abilities. They will squeeze the last bit of
performance out of them.

> to have sharp teeth nor any apparent poison fangs) - i simply concur
> with the reasons Peter listed that it is a technically inferior
> solution.

Ok so you are saying that the reduction of OS latencies will make the
processor completely available and have no disturbances like OFFLINE scheduling?

Peter has not given a solution to the problem. Nor have you.

