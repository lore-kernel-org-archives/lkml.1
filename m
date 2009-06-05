Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZFEOqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZFEOqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbZFEOpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:45:55 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:44987 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZFEOpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:45:54 -0400
Message-ID: <4A292F9E.6020602@nortel.com>
Date: Fri, 05 Jun 2009 08:45:50 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Paul Menage <menage@google.com>,
       bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
References: <20090604053649.GA3701@in.ibm.com> <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com> <4A291753.7090205@redhat.com> <20090605134320.GA3994@linux.vnet.ibm.com>
In-Reply-To: <20090605134320.GA3994@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2009 14:45:53.0530 (UTC) FILETIME=[53A785A0:01C9E5EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:

> Shares cannot be used to provide guarantees. All they decide is what
> propotion groups can get CPU time. (yes, shares is a bad name, weight
> shows the intent better).

If I (as the administrator of the system) arbitrarily decide that all
the shares/weights must add up to 100, they magically become percentage
guarantees.

Chris
