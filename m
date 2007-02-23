Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbXBWRe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbXBWRe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 12:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932459AbXBWRe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 12:34:56 -0500
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:35200 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932414AbXBWRez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 12:34:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4sZaW2Mp8YMZZBcB2wbOlqGcZYWhkpi64P6iq7NzvMM+qtk3GIvNLW90JyMXhvh0KNEjgDITMPYVcvdO6YyA4wI5OKVO+Awe0wpQcwq1u0UTgAW4MovDyJ3JV4YdkTya3BwfUXADj79IBhmHFTpkmKq7Zxu5VL7UKcZJHdJ7/Ic=  ;
X-YMail-OSG: 6RznE3EVM1kGpadbCbJi_tcSlXBa0AMQ9SQfIPou5YjwaPFnQdgeekq_GqtLAdI9L_NfIj1MpcNq1xqAcTH9.xV3YnqDxp65fNtd2432Gvjk9SYBT.lvK2vPzqced2fXhg_WA3XQ62f0AQ--
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [patch/rfc 0/6] rtc framework: remove class_device, use class suspend()/resume()
Date: Fri, 23 Feb 2007 09:34:47 -0800
User-Agent: KMail/1.7.1
Cc: rtc-linux@googlegroups.com, Greg KH <greg@kroah.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>
References: <200702211945.15003.david-b@pacbell.net> <200702221421.37768.david-b@pacbell.net> <20070223130916.21f27e14@inspiron>
In-Reply-To: <20070223130916.21f27e14@inspiron>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702230934.48175.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 February 2007 4:09 am, Alessandro Zummo wrote:
>
>  given that Greg also agreed, you have my
>  Acked-By: Alessandro Zummo <a.zummo@towertech.it>

Thanks.  I'll re-issue this series in a bit with those signoffs,
after after the oops fix.  Then I expect it should sit in MM for
a while.

- Dave
