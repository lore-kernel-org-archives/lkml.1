Return-Path: <linux-kernel-owner+w=401wt.eu-S1161119AbXBAA1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161119AbXBAA1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161121AbXBAA1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:27:41 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:61300 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161119AbXBAA1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:27:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fZsr0H4kl9c1oCXHsM3AVEROox8AP0t5gEKxcw8+NIPSdTFW8mUkBC6pDqS9rYuKhcKXkOqo2jRGyMiEzE1xqk1My7XBbdEKeg/oEUJIKp9UlY7hyiCLqhjruPk9mQ2QVQIPqxL/pW4kjvU5VNIfcSNus3yvxts4KAnIr5kAoPg=
Message-ID: <45C133E9.1000600@gmail.com>
Date: Thu, 01 Feb 2007 09:27:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: fix translation for START STOP UNIT
References: <45BD4E0A.7060501@shaw.ca> <45BF5525.5040709@garzik.org> <45BF57EA.6060201@shaw.ca> <45BFE50B.7040103@rtr.ca>
In-Reply-To: <45BFE50B.7040103@rtr.ca>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Robert Hancock wrote:
>> I'd love to, but unfortunately nobody seems to have come up with a way
>> of doing this in Thunderbird that keeps it from mangling whitespace 
> 
> Yup, major nuisance.  I have to fire up Kmail whenever I'm posting patches,
> and then go back to Thunderbird again afterwards.

A much better solution with thunderbird is using external editor
extension.

http://globs.org/articles.php?lng=en&pg=2

Install the extension.  Configure it with your favorite editor.
Thunderbird won't do a thing about your message if you turn off
linewrap.

	 For example, this line starts with a tab and a space and (double tab)		is very long and I'm writing in emacs fired up from thunderbird. (double space)  

Cheers.

-- 
tejun
