Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbXJYSz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbXJYSz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758452AbXJYSzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:55:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbXJYSzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:55:44 -0400
Message-ID: <4720E689.9050509@redhat.com>
Date: Thu, 25 Oct 2007 14:55:05 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Greg KH <greg@kroah.com>, Gregory Haskins <ghaskins@novell.com>,
       stable <stable@kernel.org>, mingo@elte.hu,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH] lockdep: fix mismatched	lockdep_depth/curr_chain_hash
References: <20071005034058.20275.21559.stgit@ghaskins-t60p.haskins.net>	 <1191576686.22357.64.camel@twins> <20071008172424.GA6692@kroah.com>	 <1191864970.5797.1.camel@lappy>  <20071008173908.GA26121@kroah.com> <1193334482.6914.23.camel@twins>
In-Reply-To: <1193334482.6914.23.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2007 01:48 PM, Peter Zijlstra wrote:
> On Mon, 2007-10-08 at 10:39 -0700, Greg KH wrote:
>> On Mon, Oct 08, 2007 at 07:36:10PM +0200, Peter Zijlstra wrote:
>>> On Mon, 2007-10-08 at 10:24 -0700, Greg KH wrote:
>>>> On Fri, Oct 05, 2007 at 11:31:26AM +0200, Peter Zijlstra wrote:
>>>>> Stable team,
>>>>>
>>>>> please consider this patch for the next 22-stable.
>>>> I don't see this patch in Linus's upstream tree.  We need it there to be
>>>> able to accept it for -stable.  Or is this just a bugfix of other things
>>>> that are already in his tree?
>>> I send Linus a similar patch, haven??t seem him pick it up yet.
>>> I??ll notify you when and if he picks it up.
>> Great, that would be great for us -stable monkeys...
> 
> 3aa416b07f0adf01c090baab26fb70c35ec17623
> 
> 

And for both 2.6.22 and 2.6.23...

