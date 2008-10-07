Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbYJGPrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbYJGPrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYJGPqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:46:54 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:38705 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753789AbYJGPqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:46:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=T5LP94RUTFHpx3IO9FiAybExajXTL5cwUx5BrN1Q2pkeohTzfzwiUz3+Y46/6ABccMtNNME4L63JvUaG4OBodRxPpGtXlQX1c8mA6P3uu1i2cdMCU7hFfaBz/aavUvOD6OZibaupZQozzn7cOq5ZsBuhtRBNuGA60ao7TuWFRMQ=  ;
X-YMail-OSG: nzy.8SIVM1k2Mcs1wkHAIbEoID9N7YuHzqM78_EQ_G7SKVgt0TXqlwpLZx8QxQHN_ZzIshxP9VBW9V9K1hzSK2HyMa_gUC02Rphsx1lN8Cx3OgFpme4Uxy0i2YwwnPcUZ1yR42kGLUL4sePVAYTLxYVUJ0b0DRFZ9gRp53Pu_ZVomwGkhJQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11608] 2.6.27-rc6 BUG: unable to handle kernel paging request
Date: Wed, 8 Oct 2008 02:46:41 +1100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John Daiker" <daikerjohn@gmail.com>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.sLH.z475IB@wind>
In-Reply-To: <yWwteD.A.sLH.z475IB@wind>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080246.41871.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 October 2008 04:32, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11608
> Subject		: 2.6.27-rc6 BUG: unable to handle kernel paging request
> Submitter	: John Daiker <daikerjohn@gmail.com>
> Date		: 2008-09-16 23:00 (19 days old)
> References	: http://marc.info/?l=linux-kernel&m=122160611517267&w=4

As I wrote (and you copied to the bugzilla), this looks a bitflip in
one of the ptes... But no harm in waiting for the reporter to confirm
or disprove before we strike it off the list :)
