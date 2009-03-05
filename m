Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZCEXyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZCEXyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZCEXyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:54:45 -0500
Received: from n24.bullet.mail.mud.yahoo.com ([68.142.206.163]:47310 "HELO
	n24.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753289AbZCEXyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:54:45 -0500
X-Yahoo-Newman-Id: 979352.24296.bm@omp409.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qGYvdwKLgsnLlymaADXeiQQkioNerA5PcoW1TCi51dSBmYbDVzv0u7GtV87+4yQ39vhsnvCf737OAZ7/431eH0KPbDYue6G638XQIcGzDgYEr77bkCc9kMT5Wvd+OrExHjZdNHdyWjcpd6tgVqJRxSGx0tJMQob5yCfEOmY/x5Y=  ;
X-YMail-OSG: Vn9z4A0VM1l66HKCCpFA3hRIoKu8x.Gr7_VhZ7zW4qK0zDD486MljZtTA6fvuThp4LM8YHVyGAFlPohd4_50C20VDlq.Ew1SD82Bvqmbps9l_2Gz3Wzkra2W3EP3jQGc9XuyMC_S4Di0vvAxTzacM_dDusVLAUww68ae_DoEEjXb3NROZz4xF531um.UGqgtQyAjghT_mGO3khBasMxiocMUFDOWZw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver
Date: Thu, 5 Mar 2009 15:54:40 -0800
User-Agent: KMail/1.9.10
Cc: Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Samuel Ortiz <sameo@openedhand.com>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090301144018.GA23581@frodo> <20090304090026.GC7394@dtor-d630.eng.vmware.com>
In-Reply-To: <20090304090026.GC7394@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903051554.40655.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 March 2009, Dmitry Torokhov wrote:
> Cool, I will keep it in my tree pending the threaded IRQ issue
> resolution.

Speaking of which ... I'd like to confirm that you
already have the twl4030_keypad.c driver in your tree.

That was (re) submitted via linux-input on 6-Feb, after
addressing feedback from the previous version (and cc'd to
the OMAP list), but I've not heard anything ...

http://marc.info/?l=linux-omap&m=123391069411717&w=2

I don't know of a good linux-input archive or I'd
reference the post from there.


