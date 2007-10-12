Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbXJLAfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbXJLAfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 20:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbXJLAe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 20:34:56 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:51287 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbXJLAez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 20:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UbYV5E1Tb7U/1B+KQiyWL6TN0rL0ZW7MTAemTWMJ9roUyX8FIAFVqgcoLRALTus1iwj80yru8Q0DOGUjE/teV0EldBGyLkwgWJL28HrLpuIYIPuT+Yzi+iKTOiGXCQ9/0vH0J03HM5Dr9q6Sqb5+w9I9ZgvJ/MtLJqua6q6Xo70=
Message-ID: <6e25f4cc0710111734t42f0052fh7dbb6a0eaacfa45d@mail.gmail.com>
Date: Fri, 12 Oct 2007 08:34:55 +0800
From: Dafu <maillist.linux@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: kernel panic when loading built-in E1000's driver.
Cc: linux-kernel@vger.kernel.org, danmei.wei@alcatel-sbell.com.cn
In-Reply-To: <Pine.LNX.4.64.0710101033170.25413@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6e25f4cc0710100055xeeebca4ve037e56b2ef6ba6@mail.gmail.com>
	 <Pine.LNX.4.64.0710101033170.25413@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your reply.

As the commonsense, what is the difference between module and built-in driver?

As I know, cleanup function of built-in driver will not be called.
What is the other difference?

Thanks!
Dafu

On 10/10/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Wed, 10 Oct 2007, Dafu wrote:
>
> > When I run linux kernel ver2.6.10 built by myself, there was a kernel
> > panic when loading E1000 device driver. (See the details below.)
>
> Hi,
>
> 2.6.10 is a pretty ancient kernel, a load of bugfixes happened since then.
> Please recent kernel first.
>
> --
> Jiri Kosina
>
