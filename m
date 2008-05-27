Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYE0Nlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYE0Nlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbYE0Nln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:41:43 -0400
Received: from valhalla.ausics.net ([58.96.38.4]:36483 "EHLO
	valhalla.ausics.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451AbYE0Nlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:41:42 -0400
X-AIS-Watermark: 1212500486.53877@CXlGRnFlMubWrH+r4NaWmw
Subject: Re: PROBLEM: Serial error
From: "Noel   (Sourceforge)" <noelb@users.sourceforge.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <483C0CDD.2000409@gmail.com>
References: <1211836442.5745.1.camel@roswell.ausics.net>
	 <483B3B7C.1000306@gmail.com>  <483C0CDD.2000409@gmail.com>
Content-Type: text/plain
Organization: Supporting Open Source
Message-Id: <1211895684.1698.10.camel@roswell.ausics.net>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-7) 
Date: Tue, 27 May 2008 23:41:24 +1000
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-27 at 23:30, Jiri Slaby wrote:
> Jiri Slaby napsal(a):
> > On 05/26/2008 11:14 PM, Noel (Sourceforge) wrote:
> >> serial comms error with smsclient  >2.6.25 , worked fine up until and
> >> including 2.6.24.7
> 
> There is >2.6.25. It means post 2.6.26-rc1 inclusively?
> 

Yes, it broke as of 2.6.25 , I also obtained  .1 through .4 and still
broken in each, I have not tried  2.6.26-rc1 as I assume the code
breaking this is still in the tree



> 
> If you double checked this, trying to CC Alan if he doesn't have a clue.
> For reference:
> http://lkml.org/lkml/2008/5/26/260

Yes, checked.

Thanks
Noel


