Return-Path: <linux-kernel-owner+w=401wt.eu-S1763599AbXFSBtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763599AbXFSBtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 21:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbXFSBtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 21:49:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853AbXFSBtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 21:49:17 -0400
To: "David Schwartz" <davids@webmaster.com>
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKEEDHELAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 22:49:07 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEEDHELAC.davids@webmaster.com> (David Schwartz's message of "Mon\, 18 Jun 2007 14\:39\:47 -0700")
Message-ID: <or4pl4af3g.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, "David Schwartz" <davids@webmaster.com> wrote:

>> > Any number of ways. For example, you probably don't connect the
>> > serial ports
>> > to a device I have access to.

>> But you're not the user of the software on my laptop.  I am.

> Even when I get web pages from your web server?

Yes.  I'm (hypothetically) running the web server such that it serves
web pages to you or anyone else.  You don't become user of a software
just because you establish a network session with it.  You clearly
need more than that.

That said, the precise threshold isn't clear.  For complex web
applications that run part on the client and part on the server, or
even almost entirely on the server, one can argue that a user is
indeed using the software even though it runs mostly on the server.
Some people call this kind of situation the ASP loophole in the GPL.
I'm not sure I want to disturb users of this list with the details
about this, but I'd be pleased to discuss this off the list.

>> The requirements as to "installation information" apply to conveying
>> the program along with a user product.

> In other words, the GPLv3 *compels* a critical authorization decision to
> follow the physical possession of the device. Do you see that, as far as the
> GPLv2 is concerned, this is from outer space?

Not really.  When a user receives a copy of the software, there's
distribution going on, and that's when the user can start having any
expectations of having her freedoms respected as to that software.

>> > How exactly does the GPLv3 specify who should and should not be able to
>> > change the software on a particular physical machine?

>> IANAL, but my understanding is that (paraphrasing), when you convey
>> the software along with a user product, you must permit the recipient
>> of the software to install and run modified versions of the software
>> in the user product as well.

> Which is totally alien to everything in the GPLv2, word and spirit. It never
> required any authorization decisions be made any particular way, nor even
> hinted that authorization decisions were within its scope.

It's the authorization decisions that are alien to GPLv2.  That's just
yet another form of denying users the freedoms that they ought to
receive along with the software.

> What does the spirit of the GPLv2 say about who is authorized to modify the
> software on some particular piece of hardware?

It doesn't.  Why should it have to?  Whether someone is authorized or
not is a direct consequence of the freedoms.  The moment the software
was distributed to you, you're entitled to the freedoms.  Imposing
restrictions on them is a violation of the spirit, if not the letter,
of the license.

>> What if the authority that controls the use of the hardware is
>> forbidding from restricting this possibility by law?  By contractual
>> provisions?  By a patent license?  By a copyright license?

> Those kinds of things are totally alien to the GPL, which was about getting
> the source code and being able to modify it and use it on any hardware for
> which you were authorized to do so.

This is a very limited reading of the GPL that leaves out one of its
most important provisions: the bit about "no further restrictions".

> The GPL was never, until GPLv3, about who gets to make
> authorization decisions.

I can agree with that.  As long as the authorization decisions are not
used as means to deprive users' of the freedoms that must not be
restricted, they can be whatever the distributor fancies.

> You are taking my claim out of contect. I am distinguishing legal obstacles
> from *authorization* obstacles, not technical obstacles.

It doesn't matter how elaborate the excuse to disrespect the freedoms
of the user is.  If there are further restrictions to them, then this
violates the spirit, if not the letter, of the GPL.

>> Someone else's hardware is just a distraction.  You're not a user of
>> software on someone else's hardware.  You have no rights over that.

> You are. In the case of TiVo, the hardware (specifically the right
> to decide what software runs on that hardware) is someone
> else's. That is part of the bundle of rights that owning a piece of
> hardware includes. That is a right you simply do not have with TiVo.

Ah, ok, so I was sloppy above and you caught that.

If someone else places hardware on your home for you to use, even if
they still own it, then you can be a user of someone else's hardware.
And at that point the GPL kicks in, because the software was
distributed to you (even if the hardware wasn't sold), and with the
distributed software come the freedoms, which, per the GPL, the
distributor must not disrespect.

>> > And I think they change it utterly by treating one piece of hardware
>> > different from others for GPL purposes.

>> No, it's tivoization that does this.

> How so?

Like this:

>> Tivoizers say "hey, you can still modify and run the software, just
>> not on *this* hardware".

Tivoization is treating the hardware that comes along with the
software as if it was different from others.  But it isn't.

> Exactly. The GPL is about rights that apply to *all* hardware, not some one
> specific piece.

Exactly!  Just like the GPL doesn't permit the distributor to state
"BTW, you can't install or run this software on your mother's
computer", it doesn't permit the distributor to state "BTW, you can't
install or run this software on this computer I'm selling you".  The
"no further restrictions" applies equally to all computers.  It's not
just because you have some control over some particular hardware that
you deliver along with the software that you're entitled to use that
to limit the user's freedoms.

>> GPLv3 says you must make this artificial distinction.  You must not
>> place barriers on the freedoms of the user WRT to the GPLv3 software
>> they use on the hardware you sold/rented/leased/lent/gave them along
>> with the GPLv3 software you meant them to use.

> Which is a massive departure from the previous GPL spirit which was about
> being able to use the software on *ANY* hardware you controlled, not some
> special pieces more than others.

It doesn't make the sold hardware special.  How come you think it
does?  It's exactly the opposite.  It just says the distributor can't
make the hardware special, so as to restrain the users' freedoms that
are inseparable from the software.

>> You can't waive your hands to escape your obligations saying "you can
>> run it elsewhere", in just the same way you can't escape your GPLv2
>> obligations to provide source code saying "you can download it
>> elsewhere"

> That's a nonsensical comparison. You can run it on any hardware for which
> you have the right to say what software runs.

And why don't I have the right to say what software runs on the
hardware I received along with the GPLed software?  Because the
tivoizer doesn't want me to.  The tivoizer is placing barriers such
that I cannot adapt the GPLed software included in that device to my
own needs.  How is that not a further restriction to the four
freedoms?  How is that not making that hardware special?

> Because that is not a right the vendor chooses to give to the user.

As in, the vendor can turn to the user and sue her for patent
infringement, after distributing GPLed software to her, just because
the use of the patent is not a right the vendor chooses to give to the
user?

> You may dislike this decision, but it's not irrational.

I never said it was irrational.  I just said it's a further
restriction on the exercise of the freedoms that must accompany the
software wherever it goes.

>> > More importantly, the change in scope to claim rights over things
>> > that are not derivative works and do not include any GPL'd code is
>> > so massive that it's a change in spirit, IMO.

>> Show how patents whose licenses are implicitly granted under GPLv2 are
>> derivative works and your argument might begin to make sense.

> The GPL does not claim any control over those patents. If it included
> mandatory licensing of them, then you would have a point.

It doesn't because the US law makes that implicit.  GPLv3 makes it
explicit because it was found that it wasn't like this everywhere.

>> Oh, and user products that GPLv3 talks about *do* include GPLv3 code,
>> otherwise the license is irrelevant for them, since GPLv3 code is not
>> being conveyed.  I guess you meant something else when you wrote "do
>> not include any GPL'ed code".

> The TiVo loader does not include any GPL'ed code. The TiVo signing keys do
> not contain any GPL'ed code. If you are not claiming the GPLv3 exerts any
> control over the loader or the keys, then what is left to assure the user
> can replace the software on his TiVo?

Absence of disrespect for users' freedoms.  Any measure taken by the
vendor to disrespect them is a failure to comply with the obligations
imposed by the spirit, if not the letter, of the license.

And, just in case, IANAL ;-)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
