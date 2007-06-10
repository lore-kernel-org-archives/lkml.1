Return-Path: <linux-kernel-owner+w=401wt.eu-S1762931AbXFJSXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762931AbXFJSXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 14:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbXFJSXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 14:23:40 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:38564 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228AbXFJSXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 14:23:39 -0400
X-Greylist: delayed 1600 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jun 2007 14:23:38 EDT
Message-ID: <466C3B64.4070806@citd.de>
Date: Sun, 10 Jun 2007 19:56:52 +0200
From: Matthias Schniedermeyer <ms@citd.de>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com> <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com> <20070610162221.GA12830@suse.de>
In-Reply-To: <20070610162221.GA12830@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sun, Jun 10, 2007 at 02:24:51PM +0200, Jesper Juhl wrote:
>>  Since the common language of most kernel contributors is english I
>>  personally feel that we should stick to just that one language in the
>>  tree and then perhaps keep translations on a website somewhere. So the
>>  authoritative docs stay in the tree, in english, so that as many
>>  contributors as possible can read and update them. It would then be a
>>  seperate project to generate translations and keep them updated
>>  according to what's in the tree.  Perhaps we could get the kernel.org
>>  people to create an official space for that and then place a pointer
>>  to that site in Documentation/ somewhere.
> 
> No, I think the translated files should be in the tree proper, we have
> the space :)

Frankly i don't see the difference between this and the annual reoccurring "why can't the kernel messages be localized" discussion.
(Which is a little overdue, but maybe this replaces it this time.)

I could see the point in ONE "HOWTO" file per language to get people started, but everything else is a pointless exercise.
A developer/bug-reporter has to be able to express him-/herself in English and understand English, otherwise you can not accomplish very much.

All the points of the localized-messages discussion:
- You have to have a common language, otherwise you can't communicate.
- The translation will per definition be out of sync
- Translations tend to introduce (translation-)errors
- ...
also apply here.

A little anecdote:
Very Long ago (last millennium i think) SuSE defaulted to a german translated kernel for one release of their distribution. (And optionally for a few more)
But even though i'm german i couldn't understand a single word.


And here is the FAQ-Entry about the annually reoccurring discussion:
http://www.tux.org/lkml/#s9-16





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated,
cryptic, powerful, unforgiving, dangerous.

