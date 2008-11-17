Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbYKQU32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbYKQU32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYKQU3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:29:20 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63839 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178AbYKQU3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:29:19 -0500
Date: Mon, 17 Nov 2008 15:27:04 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Shem Multinymous <multinymous@gmail.com>, "J.R. Mauro" <jrm8005@gmail.com>,
       tpctl-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Tpctl-users] Inclusion of tp_smapi module into kernel?
Message-ID: <20081117202704.GG14523@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shem Multinymous <multinymous@gmail.com>,
	"J.R. Mauro" <jrm8005@gmail.com>, tpctl-users@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <200811171455.50039.hanno@hboeck.de> <49219DF5.5040404@zytor.com> <3aaafc130811170913o761ce43fg3a2738586ebd2396@mail.gmail.com> <41840b750811171035w63c794aepaa273bc55fbaf2@mail.gmail.com> <4921C425.7020806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4921C425.7020806@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 11:21:09AM -0800, H. Peter Anvin wrote:
>> We've discussed that in private at the time, and recently on LKML too.
>> In summary:
>> I'm fine with that, and so is everybody I talked to (including Linus),
>> except Greg KH who vetoed it since he believes the code is irrevocably
>> and contagiously evil.
>>
>
> Signed-off-by is about copyright, it's not a review issue.  It means "I  
> certify that I know that the author had the rights to submit this code."  
>   Code quality is important but separate.

Indeed; so what were Greg KH's complaints, specifically?  Were they a
code review issue or was just complaining about the anonymity issue?
(Note that Shem has also been willing to disclose is identity to
someone who would be willing/able to vouch that he's a real person,
and so we would have just as much legal traceability back to him as
any other piece of code which was submitted with a Signed-off-by.)

        	      	  	   	      - Ted
