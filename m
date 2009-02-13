Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbZBMVVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbZBMVVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZBMVVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:21:32 -0500
Received: from outbound-mail-30.bluehost.com ([69.89.17.212]:54240 "HELO
	outbound-mail-30.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752727AbZBMVVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:21:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=U2PUy2GBjrrggPf6UQgA8q19nFzsaRa9DuwaVh0Wp+4GONWcVwL8k12/fRzR9EoONhsCY6xDVqjISLsYzx4vF0kxQaPY2cnNhO9OIHQwJJ6FzMRsgTD47YjWDT73Jt6C;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/2] PCI: quirks, don't mark one netmos as class other
Date: Fri, 13 Feb 2009 13:21:28 -0800
User-Agent: KMail/1.9.10
Cc: akpm@linux-foundation.org, linux-serial@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1228749555-21363-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1228749555-21363-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131321.29530.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 8, 2008 7:19 am Jiri Slaby wrote:
> Let it as serial, since it doesn't have subdevice in the form of 0x00PS.
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

Ok, applied this one for real now, to my linux-next branch. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
