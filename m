Return-Path: <linux-kernel-owner+w=401wt.eu-S1764003AbXGZXkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764003AbXGZXkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932317AbXGZXkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:40:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:57338 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764543AbXGZXkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=globejDxcczAwhYp+DOfiIqOci9OUPR7nwzVhWeHZpyG0gV/BuC602GC6qK5LEF+LvIyZJiueX5tCdY5+F1hn6lsfVU/lJzQUh5L/RKMNJzdOuXTNWnVLMnRMk6aOYDtjmDNVIQCswkvmbnHgSVGCKK4RpXoMu4uuw/QJfvjzJA=
Message-ID: <9a8748490707261640k5e3e751br8a9699cff75e4a6a@mail.gmail.com>
Date: Fri, 27 Jul 2007 01:40:01 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: PNP: Lindent all source files
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       bjorn.helgaas@hp.com
In-Reply-To: <46A928D2.6030702@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A928D2.6030702@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/07/07, Simon Arlott <simon@fire.lp0.eu> wrote:
> Does anyone ever review what Lindent does? There's a fix up patch after this
> but it missed this at the very top of the patch and the labels.
>
Lindent is by no means perfect and if you use it you should always
review the changes it makes by hand.
Feel free to fix it up/improve it.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
