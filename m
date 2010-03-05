Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0CEGKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:10:44 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:19252 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083Ab0CEGKm (ORCPT
	<rfc822;groupwise-jlee@novell.com:4:1>);
	Fri, 5 Mar 2010 01:10:42 -0500
Message-Id: <4B913B0D0200002300014364@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 04 Mar 2010 23:10:37 -0700
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <mzxreary@0pointer.de>, <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 58/62] msi-laptop: Support some MSI 3G netbook that
	 is need load SCM
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew, 

於 四，2010-03-04 於 17:09 +0000，Matthew Garrett 提到：
> On Thu, Mar 04, 2010 at 10:07:53AM -0700, Joey Lee wrote:
> > Thank's for your review and suggestion.
> > Per discuss for msi-laptop patchset, I will submit a bit patch for the
> > following change:
> > 	- remove threeg sysfs interface.
> > 	- add KEY_RFKILL keymapping to msi-laptop.
> 
> If the key event comes through the keyboard controller, there's no need 
> to add the mapping to msi-laptop. Doing it through udev or hal is fine.
> 

Thank's fully undertood, now, will send patch for remove threeg sysfs
interface.


Joey Lee

