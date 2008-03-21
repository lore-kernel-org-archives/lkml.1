Return-Path: <linux-kernel-owner+w=401wt.eu-S1761719AbYCUVFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761719AbYCUVFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbYCUVFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:05:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43072 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761431AbYCUVFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:05:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: Proper way to invoke suspend?
Date: Fri, 21 Mar 2008 22:05:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-main <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20080321203040.99655491.Kristoffer.Ericson@Gmail.com>
In-Reply-To: <20080321203040.99655491.Kristoffer.Ericson@Gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803212205.10327.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 of March 2008, Kristoffer Ericson wrote:
> Rafael,

Hi,

> Been looking around for examples, but obviously something I don't understand. 
> Currently I set apm_queue_event(APM_USER_SUSPEND) inside the power button interrupt, this does nothing.
> 
> However if I cat the state, it goes into suspend. Resume fails but thats another question.

Well, I have a little experience with APM.  If you told me some more details
about what you're after, that would be helpful.

Thanks,
Rafael
