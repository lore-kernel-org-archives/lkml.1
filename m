Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbXBVWVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbXBVWVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXBVWVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:21:41 -0500
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:37524 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751982AbXBVWVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:21:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BqPxcky16/JfhSbihCobtXnBwXHfGAYgWZevbnibfo7GmHdMKH5Ihz1/Ov+Xcf9SEK8qR51Wp14giv41GG5g4RTGo0shevIqJ1dAsWygQJfq3QLOZyt5Fa3FHQfVXllRqc7eAHrIrCzJslBH0+Y5hk2F5aIwZkaMdx7XonK989s=  ;
X-YMail-OSG: zNkEwhEVM1lBrM_RPw5w2wZS5po1chLOo2RlSYPER5LxiID.jwDWlXa06UYqX6vx6NaTnF_7OBf0V6CJ2UGr.mVPZlouX.4iuuDMl6rPpy4mRw--
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [patch/rfc 0/6] rtc framework: remove class_device, use class suspend()/resume()
Date: Thu, 22 Feb 2007 14:21:36 -0800
User-Agent: KMail/1.7.1
Cc: Greg KH <greg@kroah.com>, rtc-linux@googlegroups.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>
References: <200702211945.15003.david-b@pacbell.net> <200702221244.32442.david-b@pacbell.net> <20070222223758.55fce4b3@inspiron>
In-Reply-To: <20070222223758.55fce4b3@inspiron>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702221421.37768.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 February 2007 1:37 pm, Alessandro Zummo wro
>  Hi David,
> 
>   thanks for your work. The interface system was originally
>  in place because it seemed the right-thing-to-do. if it isn't,
>  better to remove it ;)

The Right Thing may also have changed a bit over time!

- Dave
