Return-Path: <linux-kernel-owner+w=401wt.eu-S1945914AbXBBP1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945914AbXBBP1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945911AbXBBP1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:27:09 -0500
Received: from qb-out-0506.google.com ([72.14.204.237]:13871 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945914AbXBBP1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:27:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SaljPWXVXna4/sKq/sDKkHhW/Z1r4lIORo7kErrKo0o9ie2SHasBarGcLC6BaGzQ1MNuj2nOHRrRPebTyvPpGdMg1NXqm5Hc2l34xjP7vwuE51Lul49OuBBHpw6Ce5jAqhaYN1tZsEqe0OGzz35ceyJiwWLEV5PCa/cWDlnqZN4=
Message-ID: <38b2ab8a0702020727k7501451aj5ce350027e3eeb85@mail.gmail.com>
Date: Fri, 2 Feb 2007 16:27:06 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: Slower CPU frequency reported by the kernel
Cc: "Paolo Ornati" <ornati@fastwebnet.it>, linux-kernel@vger.kernel.org
In-Reply-To: <1170426010.3073.932.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0702020311o54789ef6xff819dc3b492b005@mail.gmail.com>
	 <20070202130408.05212b10@localhost>
	 <38b2ab8a0702020603h480fc1dfm22267089341cbe0e@mail.gmail.com>
	 <1170426010.3073.932.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/07, Arjan van de Ven <arjan@infradead.org> wrote:
> it may be userspace, or you may be using the "ondemand" governer. If you
> have the userspace tool it's often called "cpuspeed", but it depends on
> your distro.

you're right, I actually use 'ondemand' governer. It seems to be the
governer used by Fedora when the cpu is a AMD 64 3000+

thanks
-- 
Francis
