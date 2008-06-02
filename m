Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYFBNLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYFBNLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbYFBNLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:11:01 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:36216 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbYFBNLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:11:00 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [Bug #10825] appletouch after wakeup
Date: Mon, 2 Jun 2008 15:10:36 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Justin Mattock" <justinmattock@gmail.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <200806020915.27683.oliver@neukum.org> <b6c5339f0806020544u3993a9dbh38e746449c601c5e@mail.gmail.com>
In-Reply-To: <b6c5339f0806020544u3993a9dbh38e746449c601c5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021510.37992.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 2. Juni 2008 14:44:41 schrieb Bob Copeland:
> On Mon, Jun 2, 2008 at 3:15 AM, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Montag, 2. Juni 2008 01:09:00 schrieb Justin Mattock:
> >> On Sun, Jun 1, 2008 at 7:37 PM, Justin Mattock <justinmattock@gmail.com> wrote:
> >> > On Sun, Jun 1, 2008 at 6:29 PM, Oliver Neukum <oliver@neukum.org> wrote:
> >
> >> >> Please also apply the patch from the following link:
> >> >> https://bugzilla.novell.com/attachment.cgi?id=213908
> >
> > Is this a statistically significant number of tests? How often did you see
> > the appletouch problem? Can we consider this regression to be fixed by
> > this patch?
> 
> [CCed Johannes since we discussed the original problem in a separate thread]
> 
> Oliver,
> 
> Is the RESET_RESUME quirk needed in addition to the Novell bugzilla patch?

You need both.

	Regards
		Oliver
