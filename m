Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbZESKbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbZESKbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbZESKbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:31:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:50036 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZESKbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:31:24 -0400
Subject: Re: tip: patches in git for irq and numa
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090519093754.GH31404@elte.hu>
References: <4A0A6700.3070100@kernel.org> <20090513133635.GB7384@elte.hu>
	 <4A0AFA6E.5050200@kernel.org> <20090515173521.GA29647@elte.hu>
	 <4A0DE0ED.6090402@kernel.org> <20090518072952.GA12460@elte.hu>
	 <1242654650.26820.429.camel@twins> <4A1178D5.5050900@kernel.org>
	 <1242659477.26820.433.camel@twins> <4A119990.9020606@kernel.org>
	 <20090519093754.GH31404@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 19 May 2009 12:31:02 +0200
Message-Id: <1242729062.26820.488.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 11:37 +0200, Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > please check following patch
> > 
> > Thanks
> 
> I've applied it to tip:irq/numa, thanks Yingai. Pushed it out into 
> tip:master - Peter please check wether:
> 
>   3b44254: Merge branch 'irq/numa'
> 
> or later versions of -tip work fine on your Opteron box.

v2.6.30-rc6-1624-g3b44254

seems to boot again.
