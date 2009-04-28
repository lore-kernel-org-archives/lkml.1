Return-Path: <linux-kernel-owner+w=401wt.eu-S1762655AbZD1Qtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762655AbZD1Qtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761293AbZD1QtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:49:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:52521 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762434AbZD1QtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:49:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=raWEt6+qH1mvP77nBckYlPw2etzfgDXjnEWyGptjsoBcKqXdahPWXp7EMwJ9NyTgHA
         /RigEn5+EbFYu9cutVDH+e6BqwSk6WQpJplCE+mtaUtvQ3BneOWePO5HrgvtMlQCn93F
         E0cojT8f2qWD9OEzRkOhX7VnYCgb17H5jhvOg=
Date: Tue, 28 Apr 2009 18:48:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: LTTng "TIF_KERNEL_TRACE"
Message-ID: <20090428164857.GB7337@nowhere>
References: <20090428132037.GA27519@Krystal> <20090428150102.GB26546@elte.hu> <20090428154046.GA32381@Krystal> <20090428163300.GD5978@nowhere> <alpine.DEB.2.00.0904281242380.8066@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904281242380.8066@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 12:43:25PM -0400, Steven Rostedt wrote:
> 
> On Tue, 28 Apr 2009, Frederic Weisbecker wrote:
> > 
> > I don't know why I used irqsave here, I guess I was tired.
> 
> It was the "when in doubt use irqsave", or was it the "I don't want to 
> think about it, use irqsave" ;-)


A bit of the former and the latter...
It was "Argh, it's too late, I should have gone to my bed several hours ago,
just use irqsave..." :-/

 
> -- Steve
> 

